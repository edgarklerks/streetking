/* Expr dinges parser */

TemplateEvaluator = {

    evaluate: function(ast, data) {

        function TokenVal(w){
            this.w = w;
        }
        function TokenOp(){
        }
        TokenOp.prototype.getPrec = function(){
            return this.prec;
        }
        TokenOp.prototype.getFix = function(){
            return this.fix;
        }

        /* -+/*&^%| != == */

        function TokenPlus(){
            this.fix = 'left';
            this.prec = 6;

        }
        TokenPlus.prototype = new TokenOp;
        TokenPlus.prototype.constructor = TokenPlus;

        function TokenMul(){
                this.fix = 'left';
                this.prec = 7;
        }
        TokenMul.prototype = new TokenOp;
        TokenMul.prototype.constructor = TokenMul;

        function TokenMin(){
            this.fix = 'left';
            this.prec = 6;
        }
        TokenMin.prototype = new TokenOp;
        TokenMin.prototype.constructor = TokenMin;

        function TokenDiv(){
            this.fix = 'left';
            this.prec = 7;
        }
        TokenDiv.prototype = new TokenOp;
        TokenDiv.prototype.constructor = TokenDiv;

        function TokenEq(){
            this.fix = 'right';
            this.prec = 4;
        }
        TokenEq.prototype = new TokenOp;
        TokenEq.prototype.constructor = TokenEq;

        function TokenNeq(){
                this.fix = 'right';
                this.prec = 4;

        }
        TokenNeq.prototype = new TokenOp;
        TokenNeq.prototype.constructor = TokenNeq;

        function TokenAnd(){
            this.fix = 'right';
            this.prec = 3;
        }
        TokenAnd.prototype = new TokenOp;
        TokenAnd.prototype.constructor = TokenAnd;

        function TokenOr(){
            this.fix = 'right';
            this.prec = 2;
        }
        TokenOr.prototype = new TokenOp;
        TokenOr.prototype.constructor = TokenOr;

        function TokenXor(){
            this.fix = 'right';
            this.prec = 2;
        }
        TokenXor.prototype = new TokenOp;
        TokenXor.prototype.constructor = TokenXor;

        function TokenMod(){
            this.fix = 'left';
            this.prec = 7;
            
        }
        TokenMod.prototype = new TokenOp;
        TokenMod.prototype.constructor = TokenMod;

        function TokenGT(){
            this.fix = 'right';
            this.prec = 4;
        }
        TokenGT.prototype = new TokenOp;
        TokenGT.prototype.constructor = TokenGT;

        function TokenLT(){
            this.fix = 'right';
            this.prec = 4;
        }
        TokenLT.prototype = new TokenOp;
        TokenLT.prototype.constructor = TokenLT;

        function TokenGTE(){
            this.fix = 'right';
            this.prec = 4;
        }
        TokenGTE.prototype = new TokenOp;
        TokenGTE.prototype.constructor = TokenGTE;

        function TokenLTE(){
            this.fix ='right';
            this.prec = 4;
        }
        TokenLTE.prototype = new TokenOp;
        TokenLTE.prototype.constructor = TokenLTE;
        function TokenOpenP(){
        }

        function TokenCloseP(){

        }

        // Functions can have sub expressions 
        function TokenFunc(name){
            this.name = name;
            this.sub = [];
        }
        TokenFunc.prototype.wrap = function(sub){
            this.sub = sub;
        }
        TokenFunc.prototype.map = function(f){
                var b = new TokenFunc(this.name);
                b.wrap(f(this.sub));
                return b;
        }


        function exprTokenParser (tokens){
        function preparser(tokens){
            var tr = [];
            var ftr = function(name){
                switch(name){
                    case '+':
                    return new TokenPlus();
                    case '-': 
                    return new TokenMin();
                    case '*':
                    return new TokenMul();
                    case '/':
                        return new TokenDiv();
                    case '&':
                    return new TokenAnd();
                    case '|': 
                        return new TokenOr();
                    case 'xor':
                        return new TokenXor;
                    case '%':
                        return new TokenMod;
                    case '==':
                        return new TokenEq;
                    case '!=':
                        return new TokenNeq;
                    case '>':
                        return new TokenGT;
                    case '<':
                        return new TokenLT;
                    case '>=':
                        return new TokenGTE;
                    case '<=':
                        return new TokenLTE;
                }
            };
            
            for(var j in tokens){
                switch(tokens[j].token){
                    case 'val':
                        tr.push(new TokenVal(tokens[j].val));
                    break;

                    case 'unary':
                        tr.push(new TokenFunc(tokens[j].name));
                    break;
                    
                    case 'binary':
                        tr.push(ftr(tokens[j].name));
                    break;
                    
                    case 'open':
                        tr.push(new TokenOpenP);
                    break;
                    
                    case 'close':
                        tr.push(new TokenCloseP);
                    break;
                }
            }
            return tr;
            
        }




        // Three passes:
        // Fase1: First recognize and collapse all the functions and their subexpressions 
        // Fase2: Transform to reverse polish notation
        // Fase3: Fabricate AST from reverse polish notation. 
        // 
        // EXAMPLE: 1 + 2 * 3
        /*
        var base = [new TokenVal(1), new TokenPlus(), new TokenVal(2), new TokenMul(), new TokenVal(3)];
        // EXAMPLE_F: 1 + abs(5 - 10 * 3) / 5
        var case1_fase1 = [new TokenVal(1), new TokenPlus(), new TokenFunc('abs'), new TokenOpenP(), new TokenVal(5), new TokenMin(), new TokenVal(10), new TokenMul(), new TokenVal(3), new TokenCloseP(), new TokenDiv(), new TokenVal(5)]
        var case2_fase1 = [new TokenFunc('test'), new TokenVal(20), new TokenPlus(), new TokenVal(10)];
        var case3_fase1 = [new TokenFunc('test'), new TokenFunc('test2'), new TokenVal(10), new TokenPlus(), new TokenVal(20)];
        var case3_enc_fase1 = [new TokenFunc('test'), new TokenOpenP(), new TokenFunc('test2'), new TokenVal(1), new TokenCloseP()];
        */
        // Three valid cases:
        // (1) TokenFunc, <- (TokenOpenP .. expr .. TokenOpenP)
        // (2) TokenFunc, <- (TokenVal)  
        // (3) TokenFunc <- (TokenFunc  expr)


        function fase1Parser(tokens){
            var case1 = function(tokens, d){
                    if(!d) d = 0;
                    var stack = [];
                    var func = false;
                    var tags = 0;
                    while(tokens.length > 0){
                        var ins = tokens.shift();
                        if(ins instanceof TokenFunc && !func){
                            func = ins;
                            // Check special case

                            var ts = tokens.shift();
                            tokens.unshift(ts);
                            if(ts instanceof TokenFunc){
                                var b = case1(tokens, d+1);
                                tokens = b[1];
                                stack.push(b[0]);
                            }
                            continue;
                        }
                        if(ins instanceof TokenOpenP && func){
                            if(tags != 0){
                                    stack.push(ins);
                            } 
                            tags++;
                            continue;
                        }
                        if(ins instanceof TokenCloseP && func){
                                tags--;
                                if(tags == 0){
                                    func.wrap(stack);
                                    return [func, tokens];
                                } else {
                                    stack.push(ins);
                                }
                                continue;
                        }
                        stack.push(ins);

                    }
                    throw "fase1 failed hard, have fun dipshit";
                
            }
            // Scan over all tokens to find functions. 
            var processed = [];
            while(tokens.length > 0){
                    var op = tokens.shift();
                    if(op instanceof TokenFunc){
                        tokens.unshift(op);
                        var b = case1(tokens);
                        tokens = b[1];
                        processed.push(b[0]);
                    } else {
                        processed.push(op);
                    }
            }
            return processed;

        }
        function fase2Parser(tokens){
            var fase2 = function(tokens){
                var output = [];
                var opstack = [];
                while(tokens.length > 0){
                    var ts = tokens.shift();
                    if(ts instanceof TokenVal){
                        output.unshift(ts);
                        continue;
                    }
                    // descend into TokenFunc
                    if(ts instanceof TokenFunc){
                        var ns = ts.map(fase2Parser);
                        output.unshift(ns);
                        continue;
                    }
                    if(ts instanceof TokenOp){
                        // examine stack
                        if(opstack.length == 0){
                            opstack.push(ts);
                            continue;
                        } else {
                            // What precedence we have?
                            while(opstack.length > 0){
                                // Getting of the opstack o2
                                var op = opstack.pop();
                                
                                // if ts is 
                                if(op instanceof TokenOp && ((ts.getFix() == 'left' && op.getPrec() >= ts.getPrec()) 
                                                || (ts.getFix() == 'right' && op.getPrec() > ts.getPrec()))){
                                        output.unshift(op);	
                                } else {
                                        opstack.push(op);
                                    // We don't need to swap operators here
                                    break;
                                }
                            }
                            opstack.push(ts);
                        }
                    }
                    if(ts instanceof TokenOpenP){
                        opstack.push(ts);	
                    }
                    if(ts instanceof TokenCloseP){
                        var done = false;
                        while(opstack.length > 0){
                            var op = opstack.pop();
                            if(op instanceof TokenOp){
                                output.unshift(op);
                                continue;
                            } 
                            if(op instanceof TokenOpenP){
                                var done = true;	
                                break;
                            }
                        }
                        if(!done){
                            throw "Mismatched parenthesis";
                        }
                    }

                }
                while(opstack.length > 0){
                    var op = opstack.pop();
                    if(op instanceof TokenOp){
                        output.unshift(op);
                    } else {
                            throw "Mismatched parenthesis";
                    }

                }
                return output;
            }(tokens);
            return fase2;
        }

        function evaluator(tokens){
            var stack = [];
            while(tokens.length > 0){
                var ts = tokens.pop();
                if(ts instanceof TokenFunc){
                        var ns = ts.map(evaluator);
                        var res = ns.sub[0];
                        switch(ns.name){
                            case 'test':
                                stack.push(res  + 1);
                                continue;
                            case 'test2':
                                stack.push(res  + 2);
                                continue;
                            case 'abs':
                                stack.push(Math.abs(res));		
                                continue;
                        }
                }
                if(ts instanceof TokenVal){
                    stack.push(ts.w);
                    continue;
                }
                if(ts instanceof TokenOp){
                    var b = stack.pop();
                    var a = stack.pop();
                    if(ts instanceof TokenPlus){
                        stack.push(a + b);
                    } else if(ts instanceof TokenMin){
                        stack.push(a - b);
                    } else if(ts instanceof TokenDiv){
                        stack.push(a / b);
                    } else if(ts instanceof TokenMul){
                        stack.push(a * b);
                    }
                    continue;
                }
            }
            return stack;
        }

        var b = preparser(tokens);
        var c = fase1Parser(b);
        var d = fase2Parser(c);
        return d;
        };


        function evaluate(ast, data) {
            if(!ast) throw "evaluate called with no syntax tree";
            if(!data) data = {}; // throw "evaluate called with no data";
            var data_clone = new scopeWrapper(data);
            var res = [];
            for(var i in ast)
                res.push(evaluateElement(ast[i], data_clone));
            return res.join("");
        }
        function evaluateElement(elt, data) {
            var ev = new evaluator();
            if(!elt.tag)
                throw "evaluateElement: no tag in AST element";
            if(!ev[elt.tag] || !(typeof(ev[elt.tag])=='function' || ev[elt.tag] instanceof Function))
                throw "Unrecognized tag: "+elt.tag;
            return ev[elt.tag].call(ev, elt, data);
        }
        function getSymbol(sym){
			glog("new symbol", (sym));
            if(sym["tag"] == 'var'){
                    return getSymbol(sym.val);
            }
            if(sym['tag'] == 'symbol'){
                    return sym.val;
            }
            throw "Die Justin Bieber, just fucking die. You supplied not a symbol. YOU SUPPLIED NOT TEH SYMBOL"; 
        }
        function getObject(obj){
			glog('new obj',obj);
            if(obj['tag'] == 'var'){
                    return getObject(obj.val);
            }
            if(obj['tag'] == 'objectaccessor'){
                    var b = [];
                    for(var i in obj.properties){
                        b[i] = obj.properties[i];
                    }
                    b.unshift(obj.object);
                    return b;
            }
            throw "This happened exactly to pancho. He didn't supply the symbol. And now you didn't supply  the object.";
        }
        function getVariable(obj){
            if(obj['tag'] == 'variable'){
                return obj.data;	
            }
            throw "NONONON BAD PANCHO. THAH IS NOT A VARIABLE>";
        }

        function getInteger(obj){
            if(obj['tag'] == 'var'){
                return getInteger(obj.val);
            } 
            if(obj['tag'] == 'integer'){
                return obj.val;
            }
            throw "Not an integer, pancho. (Yes he is back again). DANCE PANCHO DANCE.";
        }
        function getExpression(obj){
            if(typeof(obj['expr']) == 'undefined'){
                    throw "NO, I don't say it again. Fuck you pancho";
            }
            return obj['expr'];
        }
        function getInstructions(obj){
            if(typeof(obj['ins']) == 'undefined'){
                    throw "*Sigh*, it is not an instructions";
            }
            return obj['ins'];
        }
        function lookupFromScope(data, path){
                var b = data;
                for(var i in path){
                    var step = path[i];
                    if(typeof(b[step]) == 'undefined') return undefined;
                    b = b[step];
                }
                return b;
        }
        function exprEvaluation(tokens, data){
            var stack = [];
            while(tokens.length > 0){
                var ts = tokens.pop();
                if(ts instanceof TokenOp){
                        var b = stack.pop();
                        var a = stack.pop();
                        if(ts instanceof TokenPlus){
                            stack.push(a + b);
                            continue;
                        }
                        if(ts instanceof TokenDiv){
                            stack.push(a / b);
                            continue;
                        }
                        if(ts instanceof TokenMul){
                            stack.push(a * b);
                            continue;
                        }
                        if(ts instanceof TokenMin){
                            stack.push(a - b);
                            continue;
                        }
                        if(ts instanceof TokenEq){
                            stack.push(a == b);
                            continue;
                        }
                        if(ts instanceof TokenNeq){
                            stack.push( a != b);
                            continue;
                        }
                        if(ts instanceof TokenGT){
                            stack.push(a > b);
                            continue;
                        }
                        if(ts instanceof TokenLT){
                            stack.push(a < b);
                            continue;
                        }
                        if(ts instanceof TokenLTE){
                            stack.push(a <= b);
                            continue;
                        }
                        if(ts instanceof TokenGTE){
                            stack.push( a >= b);
                        }
                        if(ts instanceof TokenOr){
                            stack.push(a || b);
                            continue;
                        } 
                        if(ts instanceof TokenXor){
                            stack.push((a || b) && !(a && b));
                            continue;
                        }
                        if(ts instanceof TokenAnd){
                            stack.push(a && b);
                            continue;
                        }
                        if(ts instanceof TokenMod){
                            stack.push(a % b);
                        }
                }
                if(ts instanceof TokenFunc){
                    var ns = ts.map(function(x){ return exprEvaluation(x, data); });
                    var res = ns.sub;
                    switch(ns.name){
                        case 'abs':
                            stack.push(Math.abs(res));
                        continue;
                        case 'round':
                            stack.push(Math.round(res));
                        continue;
                        case 'floor':
                            stack.push(Math.floor(res));
                        continue;
                        case '!':
                            stack.push(!res);
                        continue;
                        case 'length':
                            stack.push(res.length);
                            continue;
                        case 'nl2br':
                            stack.push(res.replace("\r", "").split("\n").join("<br />"));
                            continue;
                        default:
                            throw "No such function: " + ns.name;
                    }
                }
                if(ts instanceof TokenVal){
                        var w = ts.w;
                        switch(w.tag){
                            case 'integer':
                                stack.push(parseInt(w.val));
                                continue;
                            case 'float':
                                stack.push(parseFloat(w.val));
                                continue;
                            case 'string':
                                stack.push(w.val);
                                continue;
                            case 'var':
                                switch(w.val.tag){	
                                    case 'symbol':
                                        var sym = getSymbol(w.val);
                                        stack.push(lookupFromScope(data, [sym]));
                                    continue;
                                    case 'objectaccessor':
                                        var props = getObject(w);
                                        stack.push(lookupFromScope(data, props));
                                    continue;
                                }
                                continue;
                            case 'symbol':
                                stack.push(lookupFromScope(data, [getSymbol(w.val)]));
                                continue;
                            case 'objectaccessor':
                                var props = getObject(w);
                                stack.push(lookupFromScope(data, props));
                                continue;
                            case 'bool':
                                if(w.val == "true"){
                                    stack.push(true);
                                } else {
                                    stack.push(false);
                                }
                                continue;
                        }
                }

            }
            return stack[0];
        }
        function evaluator() {
            return this;
        }
        /* Wrapper around the data object. Every wrapper is a new scope. */
        function scopeWrapper(data){
            this[" data"] = data;
            this.init();
            return this;
        }
        scopeWrapper.prototype.init = function(){
            var data = this[" data"];
            for(var i in data){
                this[i] = data[i];
            }
            return this;
        }
        scopeWrapper.prototype.getFirstScope = function(){
            if(this[" data"] instanceof scopeWrapper){
                return this[" data"].getFirstScope();
            }
            return new scopeWrapper(this[" data"]);
        }
        scopeWrapper.prototype.getPreviousScope = function(){
            if(this[" data"] instanceof scopeWrapper){
                return this[" data"];
            }
            return new scopeWrapper(this[" data"]);
        }


        evaluator.prototype = {
            repeat: function(elt, data_) {
                var data = new scopeWrapper(data_);
                glog("repeat", elt.args.data);
				
				var sym;
				var isObject = false;
                var data;
				try {
                    lookup = getSymbol(elt.args.data)
                } catch(e){
                    lookup = getObject(elt.args.data);
                    isObject = true;
                }
                
                if(isObject){
                    sym =  lookupFromScope(data, lookup);
                } else {
                    sym = lookupFromScope(data, [lookup]);
                }
				if(sym === undefined){
					throw "Evaluator repeat sym is not defined";
				}
				
				
                var as = getSymbol(elt.args.as);
				
                var limit = false;
                if(typeof(elt.args.limit) != 'undefined'){
                    limit = getInteger(elt.args.limit);
                }
                var ins = getInstructions(elt);
                
                if(as in data) throw "Evaluator repeat: cannot add \""+as+"\" to scope, field already exists";
                var res = [];
                
                if(typeof(sym) != 'array' && !(sym instanceof Array)) throw "symbol: " + sym + " doesn't represent an array";
                var arr = sym;
                var al = arr.length;
                for(var i=0; (i<al && (!limit || i < limit)); i+=1) {
                    data[as] = arr[i];
                    res.push(evaluate(ins, data));
                }
                return res.join('');

            },
            template: function(elt, data) {
                if(elt.ins) throw "Evaluator template: instructions not allowed for this tag";
                throw "Tag handler not yet implemented: \"Template\"";
            },
            text: function(elt, data) {
                if(elt.ins) throw "Evaluator text: instructions not allowed for this tag";
                return elt.data;
            },
            when: function(elt, data){
                var expr = exprEvaluation(exprTokenParser(getExpression(elt)), data);
                if(expr){
                    var ins = getInstructions(elt);
                    return evaluate(ins, data);
                }
                return "";
            },
            variable: function(elt, data) {
                if(elt.ins) throw "Evaluator variable: instructions not allowed for this tag";
                var lookup = getVariable(elt);
                var isObject = false;
                try {
                    lookup = getSymbol(lookup)
                } catch(e){
                    lookup = getObject(lookup);
                    isObject = true;
                }
                var path = {};
                if(isObject){
                    return lookupFromScope(data, lookup);
                } else {
                    return lookupFromScope(data, [lookup]);
                }
            },
            eval : function(elt, data){
                var expr = getExpression(elt);
                var b = exprTokenParser(expr);
                var c =  exprEvaluation(b,data);
                return c;
            }
        };
        
        return evaluate(ast, data);
    }
};
