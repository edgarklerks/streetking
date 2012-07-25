<div class="setup-car-info-data-element-image-box backgound-blue"><div class="setup-car-info-data-element-image white-icons-100 white-icons-100-car">&nbsp;</div></div>
<div class="setup-car-info-data-element-container">
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Top speed <span>[:eval floor((0.top_speed/10000))]</span> km/h</div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/10000)*100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Acceleration <span>[:eval floor((0.acceleration/10000))]</span> s</div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/10000)*100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Braking <span>[:eval floor((0.braking/10000))]</span></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/10000)*100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Handling <span>[:eval floor((0.handling/10000))]</span></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/10000)*100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Weight <span>[:eval floor((0.weight/10000))]</span> kg</div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/10000)*100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar setup-car-info-data-element-progress-used ui-corner-all-1px" style="width:[:eval floor(0.wear/1000)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>