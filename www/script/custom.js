$( document ).ready(function() {
    $('a[href="#shiny-tab-running"]').click(function(){
        $(".ui.dashboard-sidebar").css("background", "url('../images/sport-bg.png')")
    });
    $('a[href="#shiny-tab-biking"]').click(function(){
        $(".ui.dashboard-sidebar").css("background", "url('../images/bike-bg.png')")
    });
    $('#run_add-btn_display_add_run').click(function(){
        $(".add-container").toggleClass("show_flex")    
    });
    $('#bike_add-btn_display_add_run').click(function(){
        $(".add-container").toggleClass("show_flex")    
    });
});

