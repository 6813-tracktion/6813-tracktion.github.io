/**
 * Template-related functions
 */

function loadTemplates(callback){
    var templates = {};
    var urls = [];
    $('script[type="text/template"]').each(function(){
        urls.push($(this).attr('src'));
    });
    async.map(urls, function(url, cb){
        $.get(url, function(tmpl){
            var tags = $(tmpl);
            tags.find('script').each(function(){
                var id = $(this).attr('id');
                if(id){
                    templates[id] = $(this).text();
                }
            });
            $('body').append(tags);
            cb();
        }, "html");
    }, function(err){
        callback(err, templates);
    });
}

// @see http://marionettejs.com/docs/marionette.templatecache.html
// @see https://gist.github.com/unicodefreak/1901458
(function templateSystem(tplProto){
    var oldLoadTemplate = tplProto.loadTemplate;
    tplProto.loadTemplate = function(tplID, options) {
        
        return oldLoadTemplate.call(this, tplID, options);
    };
    var oldCompileTemplate = tplProto.compileTemplate;
    tplProto.compileTemplate = function(rawTemplate, options) {
        // @see comments of http://emptysqua.re/blog/adding-an-include-tag-to-underscore-js-templates/
        var self = this;
        do {
            var include = rawTemplate.replace(
                /<%=\s*include\s+(.*?)\s*%>/g,
                function(match, templateID){
                    var content = self.loadTemplate(templateID, options);
                    return content;
            });
            if(include == rawTemplate)
                break;
            else
                rawTemplate = include;
        } while(true);
        // really compile now
        return oldCompileTemplate.call(this, rawTemplate, options);
    };
})(Backbone.Marionette.TemplateCache.prototype);
