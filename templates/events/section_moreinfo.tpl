<div>
	<span>[:time]</span> Section text... 
	<span src="" title="More info" alt="More info" class="more cursor-pointer">more</span>
	<ul class="more-info" style="display:none;">
		<li>Section length: <span>[:eval floor(data.sectionLength)]</span>m</li>
		<li>Section time: <span>[:eval floor(data.sectionTime*10)/10]</span>s</li>
		<li>Speed in the start of section: <span>[:eval floor(data.sectionSpeedIn)]</span>km/h</li>
		<li>Speed in the end of section: <span>[:eval floor(data.sectionSpeedOut)]</span>km/h</li>
		<li>Top speed in the section: <span>[:eval floor(data.sectionSpeedMax)]</span>km/h</li>
	</ul>
</div>