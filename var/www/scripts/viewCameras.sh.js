var repositoryURL="https://github.com/jmirasb/opendomo-vision/";
function refreshCameras() {
	$("#viewCameras li").each(function(){
		var camid = $(this).prop("id");
		var source= $(this).find("img").prop("src").split("?",1)[0] + "?t=" + new Date().getTime();
		$("#"+camid+"_preload").on("load",function(){
			var camid = $(this).data("cam");
			$("#"+camid +"_cam").prop("src",source);	
		}).prop("src",source);
		
	});
	setTimeout(refreshCameras,1000);
}
$(function(){
	$("#viewCameras li").each(function(){
		var label   = $(this).find("b").hide().text(); 
		var camid   = $(this).prop("id");
		var filters = $(this).find("p").text().split(" ");
		$(this).find("a")
			.prepend("<img id='"+camid+"_preload' data-cam='"+camid+"' class='preload' src='/data/"+ camid +".jpg'>"+
				"<img id='" + camid + "_cam' data-cam='"+camid+"' src='/data/"+ camid +".jpg'/>");
		var buttons =  "<button class='default' type='button' data-id='" + camid + "'>"+ label + "</button>"
			+ "<button class='record'  type='button' data-id='" + camid + "'>REC</button><span class='filters'>";
		for(var i=0;i<filters.length;i++){
			if (filters[i].trim()!=""){
				buttons = buttons + "<button class='filter "+ filters[i] 
				+ "'  type='button' data-filtername='"+ filters[i] 
				+ "' data-id='" + camid + "'>"+ filters[i] + "</button>";
			}
		}
					
		$(this).append("<div class='tools ui-widget-header'>" + buttons + "</span></div>");
	});
	$("div.tools").find("button.default").on("click",function(){
		var id = $(this).data("id");
		$("#" + id + " img").prop("src","/data/" + id + ".jpg");
	});
	$("div.tools").find("button.record").on("click",function(){
		var id = $(this).data("id");
		if ($("#"+id).hasClass("recording")){
			var res = loadTXT("./stopRecording.sh?param=" + id + "&GUI=XML");
			$("#"+id).removeClass("recording");
		} else {
			var res = loadTXT("./startRecording.sh?param=" + id + "&GUI=XML");
			if (res.indexOf("error")==-1) {
				$("#"+id).addClass("recording");
			} else {
				var msg = $($.parseXML(res)).find("error").attr("description");
				alert(msg);
			}
		}
	});	
	$("div.tools").find("button.filter").on("click",function(){
		var id = $(this).data("id");
		var filter = $(this).data("filtername");
		$("#"+id+" img").prop("src","/data/" + id + "_" + filter + ".jpg");	
	});
	
	refreshCameras();
});

function startStopRecording(cam){
	console.log("Recording " + cam);
}