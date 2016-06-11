
/**
 * Copyright (c) 2016 Groundwork GIS
 * http://groundworkgis.org.uk/
 */


   
$(document).ready(function() {
    $('.sidebar-toggle').on( 'click', function (e) {
        $($.fn.dataTable.fnTables(true)).each(function(i, table) {
            var $table = $(table);
              $table.dataTable().fnAdjustColumnSizing();
        });
    });
});


