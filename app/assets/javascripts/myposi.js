function select_futures(){
  try {
    obj = document.frm_position.position_distinct;
    index = obj.selectedIndex;
    if (index == "0" || index == "1"){
      document.frm_position.position_exercise.disabled = true;
      document.frm_position.position_maturity.disabled = true;
    } else {
      document.frm_position.position_exercise.disabled = false;
      document.frm_position.position_maturity.disabled = false;
    }
  } catch(e) {
    return;
  }
}

function changeRangeValue(value) {
  document.getElementById("range_val").innerHTML = value;
}

function changeSigmaValue(value) {
  document.getElementById("sigma_val").innerHTML = value;
}

