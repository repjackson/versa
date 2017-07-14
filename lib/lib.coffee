@Climbers = new Meteor.Collection 'climbers'


Climbers.before.insert (userId, doc)->
    doc.author_id = Meteor.userId()
    doc.paired = false
    doc.registered = false
    
    return


# Docs.helpers
#     author: -> Meteor.users.findOne @author_id
#     when: -> moment(@timestamp).fromNow()

# Meteor.methods
#     add: (tags=[])->
#         id = Docs.insert
#             tags: tags
#             timestamp: Date.now()
#             author_id: Meteor.userId()

#         return id