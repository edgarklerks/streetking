
var name = "{$name}";

{q{
function failed(a){
    $.ajax({
        type : 'POST',
        url : 'result',
        data : {
                test : name,
                result : "failed"
            },
        success : function(){
        }
    });

};

function succeed(a){
    $.ajax({
        type : 'POST',
        url : 'result',
        data : {

                test : name,
                result : "ok"
            },
        success : function(){
        }
    });

}
}}
