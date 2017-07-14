Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'from_now', () -> moment(@timestamp).fromNow()

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")
# Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")



Template.registerHelper 'is_editing', () -> 
    # console.log 'this', @
    Session.equals 'editing_id', @_id


Template.registerHelper 'is_dev', () -> Meteor.isDevelopment


FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'

FlowRouter.route '/', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'home'

FlowRouter.route '/climbers', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'climbers'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'

FlowRouter.route '/recording', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'recording'

FlowRouter.route '/register', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'register'

FlowRouter.route '/profile', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'profile'

FlowRouter.route '/profile/my_info', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'profile_nav'
        main: 'profile_my_info'

FlowRouter.route '/profile/devices', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'profile_nav'
        main: 'profile_devices'


Template.climbers.onCreated ->
    @autorun -> Meteor.subscribe 'climbers'
    
Template.climbers.events
    'click #add_climber': ->
        new_climber_id = Climbers.insert {}
        Session.set 'editing_climber_id', new_climber_id
        
    'blur #change_climber_id': ->
        value = $('#change_climber_id').val()
        Climbers.update @_id,
            $set: climber_id: value
    
    'click .make_available': ->
        Climbers.update @_id,
            $set: available: true
        
    'click .remove_available': ->
        Climbers.update @_id,
            $set: available: false
        
    'click .pair_climber': ->
        swal {
            title: "Pairing with #{@climber_id}..."
            # text: "I will close in 2 seconds.",
            timer: 2000
            type: 'info'
            showConfirmButton: false
        }
        Meteor.setTimeout (->
            Climbers.update @_id,
                $set: paired: true
            FlowRouter.go '/recording'
        ), 2100
        
        
    'click .edit_climber_id': -> Session.set 'editing_climber_id', @_id
    'click #save_climber_id': -> Session.set 'editing_climber_id', null
        
Template.climbers.helpers
    climbers: -> Climbers.find()
    available_climbers: -> Climbers.find available: true
    
    is_editing_climber_id: ->
        Session.equals 'editing_climber_id', @_id