{{? typeof(sk) !== "undefined" && "data" in sk }}
	<div>
		<span>{{=sk.time}}</span> Section text... 
		<span src="" title="More info" alt="More info" class="more cursor-pointer">more</span>
		<ul class="more-info" style="display:none;">
			<li>Section length: <span>{{= Math.floor(sk.data.sectionLength) }}</span>m</li>
			<li>Section time: <span>{{= Math.floor(sk.data.sectionTime*10)/10 }}</span>s</li>
			<li>Speed in the start of section: <span>{{= Math.floor(sk.data.sectionSpeedIn)}}</span>km/h</li>
			<li>Speed in the end of section: <span>{{= Math.floor(sk.data.sectionSpeedOut)}}</span>km/h</li>
			<li>Top speed in the section: <span>{{= Math.floor(sk.data.sectionSpeedMax)}}</span>km/h</li>
		</ul>
	</div>
{{?}}