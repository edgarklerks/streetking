
    function JsonRPCRequest(uri, data, type) {
            
        this.uri = uri || false;
        this.data = data || {};
        this.type = type || 'GET';
        
        this.callbacks = {
            xhrDispatch: [],    // call just after XHR dispatch
            xhrComplete: [],    // call on XHR complete after all other callback types
            xhrError: [],       // call on XHR error
            xhrSuccess: [],     // call on XHR success
            response: [],       // call on XHR success
            result: [],         // call on XHR success with JsonRPC result
            error: []           // call on XHR success with JsonRPC error
        };

        // add a callback setter function for each callback
        var mkc = function(type) {
            return function(fun) {
                return this.callback(type, fun);
            }
        };
        for(var type in this.callbacks)
            this[type] = mkc(type);
        
        return this;
    }

    JsonRPCRequest.prototype = {

        dispatch: function() {
            this.xhr = $.ajax({
                url: this.uri,
                type: this.type,
                data: this.data,
                success: function (response, success, xhr) {
                    this.callbackCaller('xhrSuccess').apply(this, Array.prototype.slice.call(arguments));
                    this.callbackCaller('response').call(this, response);
                    
                    if(this.callbacks.error.length > 0) {
                        if((typeof(response) != 'object' && !(response instanceof Object)) || (!('error' in response) && !('result' in response)))
                            this.callbackCaller('error').call(this, 'response is not in JsonRPCRequest format');
                        else if('error' in response)
                            this.callbackCaller('error').call(this, response.error);
                    }
                    
                    if(this.callbacks.result.length > 0)
                        if('result' in response && !('error' in response))
                            return this.callbackCaller('result').call(this, response.result);
                },
                error: this.callbackCaller('xhrError'),
                complete: this.callbackCaller('xhrComplete'),
                dataType: 'json',
                context: this
            });

            this.callbackCaller('xhrDispatch').call(this, this);
            
            return this;
        },
        
        callback: function(type, f) {
        
            if(!(type in this.callbacks))
                throw "JsonRPCRequest: callback: unsupported callback type '" + type + "'";

            if(typeof(f) != 'function' || !(f instanceof Function))
                throw "JsonRPCRequest: callback: argument is not a function";

            this.callbacks[type].push(f);
            return this;
        },

        callbackCaller: function(type) {
        
            var cb = this.callbacks;
            var ct = this;
        
            if(!(type in cb))
                throw "JsonRPCRequest: performCallback: unsupported callback type '" + type + "'";
            
            return function() {
                for(var i in cb[type])
                    cb[type][i].apply(ct, Array.prototype.slice.call(arguments));
            }
        },
        
        dump: function() {
        
            // create a "dumper" callback function for debugging purposes.
            
            var mkc = function(type) {
                return function() {
                    console.group('JsonRPCRequest \''+type+'\'');
                    console.log(Array.prototype.slice.call(arguments));
                    console.groupEnd();
                };
            };
            
            for(var i=0; i < arguments.length; i++)
                this.callback(arguments[i], mkc(arguments[i]));
                
            return this;
        },
        
        debug: function() {
        
            // create a "dumper" callback function for all xhr status updates.
        
            return this.dump('xhrDispatch', 'xhrSuccess', 'xhrError', 'xhrComplete');
        }
    };
    