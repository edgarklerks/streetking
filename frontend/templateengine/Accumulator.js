
function accumulator() {
    return new Accumulator();
}

function Accumulator() {
    this.results = {};
    this.satisfied = [];
    this.conns = [];
    
    for(var i=0; i<arguments.length; i++)
        this.ready(arguments[i]);
    
    this.start = this.require();
}

Accumulator.prototype = {
    
    ready: function(f) {
    
        if(!(typeof(f) == 'function' || f instanceof Function))
            throw "Accumulator: ready: argument is not a function";
            
        this.conns.push(f);
        return this;
    },
    
    require: function(name) {
        var t = this;
        var i = t.satisfied.length;
        t.satisfied[i] = false;
        return function(res) {
            if(name)
                t.results[name] = res;
            t.trigger(i);
        }
    },
    
    trigger: function(k) {
        this.satisfied[k] = true;
        for(var i in this.satisfied)
            if(!this.satisfied[i])
                return;
        this.fire();
    },
    
    fire: function() {
        for(var i in this.conns)
            this.conns[i](this.results);
    }
}