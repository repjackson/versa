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