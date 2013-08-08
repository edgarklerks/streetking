
	function foo(o) {
		for(var i in o)
			glog('Foo', i, o[i]);
	}


    TemplateStore = (function(cfg) {
        
        var templates = {};
        var api = new JsonRPCServer(cfg.api_host);
    
        return {
        
            get: function(name) {
                if(name in templates)
                    return templates[name];
                else
                    return false;
            },
            
            put: function(name, tpl) {
                if(!(tpl instanceof Template))
                    throw "TemplateStore: put: argument is not a Template";
                templates[name] = tpl;
                return this;
            },
            
            have: function() {
                return name in templates;
            },
        
            request: function(name, success, error) {
					$.ajax({
						url: 'http://192.168.1.229:9001/Game/template',
						type: 'GET',
						data: {name: name},
						success: function (raw) {
							TemplateStore.put(name, new Template(raw));
							success(name);
						},
						error: function(err) {
							error(err);
						}
					});
			
                return this;
            }
        };
        
    })(Config);
