//this one might actually be the one that works... yeah I totally think it is
function generateArrayMaxMin(setSizeInput,minDistance, maxRelDistance, MaxDistance, minRange, maxRange) {
    var flagTest = 'bad'; // the current state of affairs 

    while (flagTest == 'bad') {
        Myarray = Array.from(Array(setSizeInput).keys());
        Myarray[0] = Math.round(getRandomArbitrary(minRange, maxRange));

        for(let rr = 1; rr < Myarray.length; rr++) { // starting at the 2nd position in the RA, since the first was our randomly picked 
            Myarray[rr] = Math.round(getRandomArbitrary(+Myarray[rr-1] + minDistance, +Myarray[rr-1] + maxRelDistance));
        }

        if  (Math.abs(Math.max(...Myarray) - Math.min(...Myarray)) > MaxDistance) {
            flagTest = 'bad';
        }
    
        if  (Math.abs(Math.max(...Myarray) - Math.min(...Myarray)) < MaxDistance) {
            flagTest = 'good';
        }
        // now shift 
        for(let kk = 0; kk < Myarray.length; kk++) {
            if (Myarray[kk] > 359) {
                       
                Myarray[kk] = +Myarray[kk] - 359;
        
            }
        }

    }
    //shuffle and output
    Myarray = jsPsych.randomization.shuffle(Myarray);
    console.log(Myarray);
    return Myarray;
    
}



// this one is old and should likely not be used
function generateArrayMaxMinOld(setSizeInput,minDistance, maxRelDistance, maxDistance, minRange, maxRange) {
    var flagTest = 'bad'; // the current state of affairs 

    while (flagTest == 'bad') {
        Myarray = Array.from(Array(setSizeInput).keys());
        Myarray[0] = Math.round(getRandomArbitrary(minRange, maxRange)); // i.e. 0 to 359

        for(let rr = 1; rr < Myarray.length; rr++) {
            Myarray[rr] = Math.round(getRandomArbitrary(+Myarray[rr-1] + minDistance, +Myarray[rr-1] + maxRelDistance));
            if (Myarray[rr] > maxRange) { //i.e. if # is > than 259
                       
                Myarray[rr] = +Myarray[rr] - maxRange;
        
            }
        }
        for(let jj = 1; jj < Myarray.length; jj++) {
           // Myarray[jj] = Math.round(getRandomArbitrary(+Myarray[rr-1] + minDistance, +Myarray[rr-1] + maxRelDistance));
            if (Myarray[jj] - Myarray[jj - 1] < minDistance) { //i.e. if # is > than 259, mindistance was 10
                       
                flagTest = 'bad';
        
            }
        }
        if  (Math.abs(Math.max(...Myarray) - Math.min(...Myarray)) > maxDistance) {
            flagTest = 'bad';
        }
    
        if  (Math.abs(Math.max(...Myarray) - Math.min(...Myarray)) < maxDistance) {
            flagTest = 'good';
        }
        for(let jj = 1; jj < Myarray.length; jj++) {
            // Myarray[jj] = Math.round(getRandomArbitrary(+Myarray[rr-1] + minDistance, +Myarray[rr-1] + maxRelDistance));
             if (Myarray[jj] - Myarray[jj - 1] < minDistance) { //i.e. if # is > than 259
                        
                 flagTest = 'bad';
         
             }
         }
    }
    //shuffle and output
    Myarray = jsPsych.randomization.shuffle(Myarray);
    console.log(Myarray);
    return Myarray;
    
}



