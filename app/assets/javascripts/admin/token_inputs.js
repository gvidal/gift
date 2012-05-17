$(document).ready(function(){
    var relation_selectors = $(".token-input")
    var i=0;
    for (i=0;i<=relation_selectors.length;i++){
        var selection = $(relation_selectors[i]);
        var limit = parseInt(selection.data('limit'));
        if(limit <= 0 || isNaN(limit) || limit == null) limit = null;
        selection.tokenInput(selection.data('href'),{
                            theme: 'facebook',
                            prePopulate: selection.data('load'),
                            tokenLimit: limit,
                            queryParam: selection.data('queryparam') || "tokens",
                            queryParamInside: selection.data('wrapparam') || "search",
                            queryOtherMethods: selection.data('querymethods') || {}
                        });
    }
});