                    
publishComposite 'doc', (id)->
    {
        find: ->
            Docs.find id
        children: [
            {
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
            }
            {
                find: (doc)->
                    if doc.attached_users
                        Meteor.users.find
                            _id: $in: doc.attached_users
            }
        ]
    }


    