

function refreshCameras() {
	$("#viewCameras li").each(function(){
		var camid = $(this).prop("id");
		var source = "/data/" + camid + ".jpg?timestamp" + new Date().getTime();
		$(this).find("img").prop("src",source);
	});
	setTimeout(refreshCameras,1000);
}
$(function(){
	$("#viewCameras li").each(function(){
		var label = $(this).find("b").hide().text(); 
		var camid = $(this).prop("id");
		$(this).find("a").prepend("<img id='" + camid + "_cam' src='/data/"+ camid +".jpg'/>");
		$(this).append("<div>" + label + "   <a href='javascript:startStopRecording(this);'>REC</a></div>");
		
	});
	refreshCameras();
});

function startStopRecording(cam){
	console.log("Recording " + cam);
}