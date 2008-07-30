// Place your application-specific JavaScript functions and classes here
//FBJS Animation stuff... 
//http://wiki.developers.facebook.com/index.php/FBJS/Animation
  function obscureDiv(div_id){
    return obscure(Animation(document.getElementById(div_id)));      
  }
  
  function obscure(animation){
     return animation.to('height', '0px').to('opacity', 0).hide();
  }
  
  function revealDiv(div_id){
    return  reveal(Animation(document.getElementById(div_id)));
  }
  
  function reveal(animation){
    return animation.to('height', 'auto').from('0px').to('width', 'auto').from('0px').to('opacity', 1).from(0).blind().show()
  }
  
  function highlight(animation){
    return animation.to('background', '#FF00FF').duration(2000).checkpoint().to('background', '#F7F7F7');
  }
  
 
 // Replace FBML 
  function updateDiv(div_id, data){
    $(div_id).setInnerFBML(data); 
  }
  
  
  //Ajax form submit with a confirmation dialog
  // http://wiki.developers.facebook.com/index.php/FBJS/Examples/Ajax
  
   // BEGIN ajax_submit_form
   function submitForm(varForm, url, div_id){ 
    try {
      //Grab the friend ID from the FORM
      name = varForm.serialize().friend_selector_name;
      friend_uid = parseInt(varForm.serialize().friend_to_step_on);
      if( friend_uid == undefined || friend_uid == 0 || isNaN(friend_uid) || name.length == 0) throw RangeError;
      
      //Confirmation Dialog sends request on Confirm    
      dlg = new Dialog(); 
      dlg.showChoice('Confirm Request', "Are you sure you want to step on " + name  +  "?" , 'Yes', 'No'); 
      dlg.onconfirm = function() { 
        var ajax = new Ajax();
        ajax.responseType = Ajax.FBML; 
        ajax.ondone = function(data) { 
          // Replace FBML 
          $(div_id).setInnerFBML(data); 
          //Animate the updated div.
          obscure(highlight(revealDiv(div_id).checkpoint()).checkpoint()).go();
        }; 
        ajax.post(url, varForm.serialize()); 
      } 
    } 
    catch(err) {
      new Dialog().showMessage("Error","Something weird happened.  Did you type in a friend?");
    }            
    return false;
  } 
  // END ajax_submit_form
  
 
  