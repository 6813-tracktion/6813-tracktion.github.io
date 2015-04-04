

Person = Backbone.Model.extend({
        defaults: {
            name: 'Fetus',
            age: 0
        },
        initialize: function(){
            alert("Welcome to this world");
            this.on("change:name", function(model){
                var name = model.get("name"); // 'Stewie Griffin'
                alert("Changed my name to " + name );
            });
        }
    });
