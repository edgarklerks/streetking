<div class="setup-car-info-data-element-image-box backgound-blue"><div class="setup-car-info-data-element-image white-icons-100 white-icons-100-car">&nbsp;</div></div>
<div class="setup-car-info-data-element-container">
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Top speed <span>[:eval floor(0.top_speed/10000)]</span> <b>km/h</b></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+0.top_speed/10000+",80,200]")]%'></div>
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px car_compare_bar_top_speed"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Acceleration <span>[:eval floor(0.acceleration/1000)/10]</span> <b>s</b></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+0.acceleration/10000+",-4,10]")]%'></div>
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px car_compare_bar_acceleration"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Braking <span>[:eval floor(0.stopping/10000)]</span> <b>m</b></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+0.stopping/10000+",-15,70]")]%'></div>
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px car_compare_bar_stopping"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Handling <span>[:eval floor(0.cornering/1000)/10]</span> <b>g</b></div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+0.cornering/10000+",0.3,1]")]%'></div>
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px car_compare_bar_cornering"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Used <span>[:eval floor(0.wear/100)]</span> %</div>
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar setup-car-info-data-element-progress-used ui-corner-all-1px" style="width:[:eval floor(0.wear/100)]%"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="setup-car-info-data-element-info-data-box">
		<div class="setup-car-info-data-element-info-data-name">Weight <span>[:eval 0.weight]</span> kg</div>
		<!--
		<div class="setup-car-info-data-element-progress-bar-box ui-corner-all-1px">
			<div class="setup-car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/10000)*100)]%"></div>
		</div>
		-->
		<div class="clearfix"></div>
	</div>
</div>