    
    function jsonRPCServer(uri) {
        return new JsonRPCServer(uri);
    }
    
    function JsonRPCServer(uri) {
        this.uri = uri;
		this.queryString = '';
    }
    
    JsonRPCServer.prototype = {
    
        get: function(res, data) {
            return this.request.call(this, 'GET', res, data);
        },

        post: function(res, data) {
            return this.request.call(this, 'POST', res, JSON.stringify(data));
        },
        
        request: function(type, resource, data) {
            return new JsonRPCRequest(this.uri + '/' + (resource || '') + this.queryString, data || {}, type || 'GET');
        },
		
		addToQueryString: function(k,v){
			if (typeof k == 'undefined' || k == '')
				return false;
		
			if (this.queryString.match(/\?/))
				this.queryString += '&'+k+'='+v;
			else
				this.queryString += '?'+k+'='+v;
		}
    }