@app.directive('knob', ->
    return {
        restrict: 'A',
        link: (scope, element, attrs) ->
            $(element).knob().val(1);
            $(element).knob().data('width', 700)
            console.log(attrs)

    };
);