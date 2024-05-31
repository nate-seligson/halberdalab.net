/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
//****************************//
//Accessory fxn useful for randomly assigning conditions
//Originally provided by Tal BOGER (Johns Hopkins)
//Adapted by Caroline MYERS (Johns Hopkins)- [10/27/22]
//Last updated by Caroline MYERS (Johns Hopkins)- [10/27/22]
//****************************//


function assignCondition() {
    // Condition - call the "file count" php file to get the condition with the least number of subjects assigned to it
    // set up range
    var list = [];
    for (var i = Math.min(...conditionsList); i <= Math.max(...conditionsList); i++) {
        list.push(i);
    }
    try {
        var conds = list.join(',');
        var xmlHttp = null;
        xmlHttp = new XMLHttpRequest();
  
        xmlHttp.open( "GET",
          'file_count_cond_select.php?dir=' + 'condition_files/' + '&conds=' +
          conds, false );
        xmlHttp.send( null );
        initial_cond = xmlHttp.responseText;
        console.log(initial_cond)
    } catch (e) {
        // var cond = 0;
        console.log('error in php file count')
        initial_cond = 'ERROR'; // this will get parsed below as NaN and then randomized
    }
    // test if cond is valid (i.e. is a number and ranges in between the lists)
    if ( isNaN(initial_cond) ) {
      console.log('Invalid condition');
      initial_cond = getRandomInt(Math.min(...conditionsList), Math.max(...conditionsList));
    };
    experimentCondition = parseInt(initial_cond,10);
    console.log("Exp. Condition: " + experimentCondition);
      try {
        filename = subjectID + '_' + experimentCondition;
        var xmlHttp = null;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.open('GET',
          'add_blank_cond_file.php?dir=' + 'condition_files/' + '&filename=' +
          filename, false);
        xmlHttp.send(null);
        out_message = xmlHttp.responseText;
        console.log('php out: ' + out_message);
      } catch (e) {
        console.log('error in php writing condition file')
      }
  };