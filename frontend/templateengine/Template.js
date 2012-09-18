
    function template(raw) {
        return new Template(raw);
    }

    function Template(raw) {
        this.ast = TemplateParser.parse(raw);
    }

    Template.prototype = {

        load: function(data) {
            return TemplateEvaluator.evaluate(this.ast, data);
        },
        
        loadMany: function(data) {
            return data.map(this.load, this);
        }
    }