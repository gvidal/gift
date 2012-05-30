/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function(){
    
   $(".datetimepicker").each(function(index, element){
        var aux_element = $(element)
        aux_element.datetimepicker({dateFormat: aux_element.data("date_format"),
                                    timeFormat: aux_element.data("time_format")}); 
   });
   
});

