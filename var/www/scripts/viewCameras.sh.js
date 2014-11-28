
setInterval(refreshCameras,1000);

function refreshCameras() {
	$("li.camera, li.zoomedcamera").each(function(index){
		var filename = "/data/" + $(this).attr("id")  + ".jpg?tstamp=" + new Date().getTime();
		$(this).find("a").css("background","url(" + filename + ") no-repeat center center");
	});
}
