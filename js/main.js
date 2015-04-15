
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

    // Give us functionality similar to Element.setCapture in all browsers.
    // Take the opportunity to centralize the 'dragging' class here too.
    window.startDrag = function(dragHandler) {
        window.dragHandler = dragHandler;
        $('body').addClass('dragging');
    };
    window.dragHandler = null;
    window.addEventListener('mousemove', function(event) {
        if (window.dragHandler) {
            window.dragHandler.mousemove(event);
        }
    });
    window.addEventListener('mouseup', function(event) {
        if (window.dragHandler) {
            window.dragHandler.mouseup(event);
            window.dragHandler = null;
            $('body').removeClass('dragging');
        }
    });

    // 1. Retrieve model - which one to load depends on url args
    var dataset;
    var isFresh = getUrlParameter('fresh');
    if (isFresh) {
      dataset = loadFreshModel();
    } else {
      dataset = loadModel();
    }

    // 2. Setup stuff ...
    setupActivity();

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

    app.weekList.show(new FullView({model: dataset}));

    // 4. Start the application
    app.start();
});
