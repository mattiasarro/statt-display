DaterangeSelector = function(attr) {
    var selector = attr.selector;
    var nr_months = typeof attr.nr_months !== 'undefined' ? attr.nr_months : 1;
    dragging = false;
    
    // Set up 1 or more datepicker widgets
    defineDatepicker(selector);
    var newDate = $(selector).datepicker("getDate");
    var prevSelector = selector;
    for (i=2; i <= nr_months; i++) {
        var new_selector = selector + i;
        var new_id = new_selector.replace('#', '');
        $('<div id="'+new_id+'"></div>').insertAfter($(prevSelector));
        
        defineDatepicker(new_selector);
        $(new_selector).datepicker(
            "setDate",
            (new Date(newDate.setMonth(newDate.getMonth() + 1)))
        );
        prevSelector = new_selector;
    }
    
    initSelected();
    function initSelected() {
        // On page load, this is set on the first calendar, causing a bug
        // because dateUnderCursor() gets day numbers from both months
        $(".ui-state-hover").removeClass("ui-state-hover");
        $(".ui-state-active").removeClass("ui-state-active");
        
        var start = $(selector).attr("data-start");
        var end = $(selector).attr("data-end");
        highlightBetween(Date.parse(start), Date.parse(end));
    }
    
    function defineDatepicker(selector) {
        var dp = $(selector).datepicker({
            firstDay: 1,
            onSelect: function() {
                $(".ui-state-active").removeClass("ui-state-active");
                $(".within_selected_range").removeClass("within_selected_range");
            }
        });
        
        dp.mousedown(function(e){
            dragging = true;
            begin_date = dateUnderCursor();
            $(".ui-state-hover").parent().addClass("within_selected_range");
        });
        
        dp.selectable({
            stop: function(event, ui) {
                dragging = false;
                end_date = dateUnderCursor();
                
                if (typeof attr.start_date !== 'undefined') {
                    var start = new Date(Math.min(begin_date, end_date));
                    attr.start_date(start);
                }
                
                if (typeof attr.end_date !== 'undefined') {
                    var end = new Date(Math.max(begin_date, end_date));
                    attr.end_date(end);
                }
                $(".ui-state-active").removeClass("ui-state-active");
            }
        });
    }
    
    // live because after datepicker.onSelect, the fucker stops working
    $("table.ui-datepicker-calendar td a").live("hover", function() {
        if (dragging == true) {
            var hover_a = $(this);
            var hover_date = getDate(hover_a);
            highlightBetween(begin_date, hover_date);
        }
    });
    
    // Helpers
    
    function dateUnderCursor() {
        var a = $(".ui-state-hover");
        var td = a.parent();
        var is_day = (td.attr("data-handler") == "selectDay");
        if (is_day == true) {
            var day = parseInt(a.text());
            var month = td.attr("data-month");
            var year = td.attr("data-year");
            return(new Date(year, month, day));
        }
    };
    
    function getDate(a) {
        var td = a.parent()
        var day = a.text();
        var month = td.attr("data-month");
        var year = td.attr("data-year");
        var date = new Date(year, month, day);
        return(date);
    }
    
    function highlightBetween(start, end) {
        var all_anchors = $("td[data-handler=selectDay] a");
        all_anchors.each(function(i,e){
            var a = $(this);
            var current_date = getDate(a);
            
            if (end < start) {
                var start_old = start;
                start = end;
                end = start_old;
            }
            
            if ((start <= current_date) && (current_date <= end)) {
                a.parent().addClass("within_selected_range");
            } else {
                a.parent().removeClass("within_selected_range");
            }
        });
    }
}
