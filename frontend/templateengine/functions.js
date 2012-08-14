
/*
// General
*/

// unix time in milliseconds
function millitime() {
    return new Date().getTime();
}

// unix time in seconds
function unixtime() {
    return Math.floor(millitime() / 1000);
}

// formatted timestamp
function timestamp(stamp) {
	
	if(stamp) {
		var currentTime = new Date(stamp);
	} else {
		var currentTime = new Date();
	}
	
	var hours = currentTime.getHours();
	var minutes = currentTime.getMinutes();
	var seconds = currentTime.getSeconds();
	
	if (minutes < 10) minutes = "0" + minutes;
	if (seconds < 10) seconds = "0" + seconds;

	return hours + ":" + minutes + ":" + seconds;
}

// general function for segmenting unix_time into groups of larger units
// eg. [weeks, days, hours, minutes, seconds] = number_segmentation(timestamp(), [7, 24, 60, 60])
function number_segmentation(n, list) {
    
    var res = [];
    
    while(list.length > 0) {
        var i = list.pop();
        res.unshift(n % i);
        n = Math.floor(n/i);
    }
    
    res.unshift(n);
    
    return res;
}


/*
// Meta functions
*/

// expose(object, method): expose a method of an object. returns a function that applies its arguments to the method in the context of the object.
function expose(obj, meth) {

	if(!(typeof(obj) == 'object' || obj instanceof Object))
        throw "Expose: argument is not an Object.";
        
	if (!(meth in obj) || !(typeof(obj[meth]) == 'function' || obj[meth] instanceof Function))
        throw "Expose: obj.'"+meth+"' is not a function.";
        
	return function() {
		return obj[meth].apply(obj, Array.prototype.slice.call(arguments));
	}
}

// curry(f): curries a function.
// f(a, b, c, ...) -> f([a, b, c, ...]) 
function curry(f) {
    return function(arg) {
        return f.apply(this, arg);
    }
}

// uncurry(f): uncurries a function.
// f([a, b, c, ...]) -> f(a, b, c, ...)  
function uncurry(f) {
    return function() {
        return f(Array.prototype.slice.call(arguments));
    }
}

// partial(f, a, b, c, ...): creates a partial function. the new function applies to the original function arguments a, b, c, ... first, and then the arguments it is supplied itself.
// partial(f, a, b) -> g(c, d) = f(a, b, c, d)
function partial(f) {

    var parts = Array.prototype.slice.call(arguments);
    var f = parts.shift();

    return function() {
        return f.apply(this, parts.concat(Array.prototype.slice.call(arguments)));
    }
}

// fdump: returns a function that executes the argument function as normal, and logs debug output to console
function fdump(func, pre, post, err) {

    if(!(typeof(func) == 'function' || func instanceof Function))
        throw "fdump: function argument is not a function";
	
    err = err || function(e, f, a) {
        glog('fdump (post-exec): exception', e);
    };

    pre = pre || function(f, a) {
        glog('fdump (pre-exec)', f.toSource ? f.toSource() : 'toSource not available', a.length, a);
    };
	
    post = post || function(r, f, a) {
        glog('fdump (post-exec): result', r);
    };

	return function() {
    
		var args = Array.prototype.slice.call(arguments);
		pre(func, args);
        
		try {
			var res = func.apply(this, args);
			post(res, func, args);
			return res;
		} catch(e) {
			return err(e, func, args);
		}
	}
}

// preventDefault: returns a function that executes the argument function as normal, but also prevents any default actions in jQuery bindings
function withPrevent(f) {
    // callback encapsulation for overriding events, preserving context and arguments for callback function
    return function(e) {
        e.preventDefault();
        e.stopPropagation();
        return f.apply(this, Array.prototype.slice.call(arguments));
    }
}


/*
// Logging
*/

// llog: log to console all elements in xs in a group with name grp
function llog(grp, xs) {

	try {
        
		if(!window.console || !window.console.log)
            return;
        
        window.console.group(timestamp()+' '+grp);
        for(var i in xs)
            window.console.log(xs[i]);
        window.console.groupEnd();
        
	} catch(e) { ; }
    
}

// glog: log to console all arguments after the first in a group with the name specified by the first argument
function glog() {
    var args = Array.prototype.slice.call(arguments);
    return llog(args.shift(), args);
}

// errlog: return a function that logs to console all its arguments in a group with name grp
function errlog(grp) {
    return partial(glog, grp);
}
