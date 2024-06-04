let data = {};
function Submit(){
    const wrapper = document.getElementById("data_wrapper");
    const children = wrapper.getElementsByTagName("*");
    data["Type"] = document.getElementById("title").innerHTML;
    let name = ""
    for(let i = 0; i<children.length; i++){
        if(children[i].nodeName == "H3"){
            name = children[i].innerHTML;
        }
        else if(children[i].nodeName == "INPUT" || children[i].nodeName == "TEXTAREA" || children[i].nodeName == "SELECT"){
            if(children[i].value.length <= 0){
                alert("Please fill all fields")
                return;
            }
            data[name] = children[i].value
        };
    }
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "http://localhost:5501/cgi-bin/server.cgi", true);
    // Set the request header i.e. which type of content you are sending
    xhttp.setRequestHeader("Content-Type", "application/json");
    // Create a state change callback

    // Converting JSON data to string
    data = JSON.stringify(data);
    console.log(data)
    xhttp.send(data);
    sendMail();
    window.location.href = "./thankyou.html"
}
function sendMail() {
    data = JSON.parse(data);
    sendFormat = ""
    const keys = Object.keys(data);
    const vals = Object.values(data);
    for(var i = 0; i<keys.length; i++){
        sendFormat += keys[i] + ":\n" + vals[i] + "\n\n"
    }
    var params = {
      type: data["Type"],
      info: sendFormat
    };
  
    const serviceID = "service_huiwda8";
    const templateID = "template_9ymlww8";
  
      emailjs.send(serviceID, templateID, params)
      .then(res=>{
          console.log("Your message sent successfully!!")
  
      })
      .catch(err=>console.log(err));
    }
window.addEventListener("DOMContentLoaded", (event) => {
document.getElementById("submitbutton").addEventListener("click", function(){Submit()})})