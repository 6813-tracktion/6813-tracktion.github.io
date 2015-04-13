
// based on: http://tutorialzine.com/2013/04/services-chooser-backbone-js/
async.waterfall([
  // 1 = wait for DOM
  function domReady(cb){
    $(document).ready(function(){
      cb();
    });
  },
  // 2 = load templates
  loadTemplates
],
  // 3 = setup application
  function initialize(err, templates){
    if(err){
      console.log('Error: %o', err);
    }

    // 1. Retrieve model
    var sessions = loadModel();

    // 2. Setup stuff ...
    
    // 3. Setup application
    var app = new Marionette.Application();
    app.addRegions({
        weekList: '#weeks',
        // activityInfo: ActivityInfo
    });
    app.on('start', function(options){
        console.log('Started Marionette application, options = %o', options);

        if(Backbone.history){
            Backbone.history.start();
        }
    });

    app.weekList.show(new FullView({collection: sessions}));

    // 4. Start the application
    app.start();
});
