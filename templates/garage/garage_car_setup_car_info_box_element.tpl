<div class="setup-info-element-container [:when (improvement > 0 & unique == false)]{setup-info-element-container-improved}[:when (unique)]{setup-info-element-container-unique} ui-corner-all">
	<div class="setup-info-element-image-container [:when (improvement > 0 & unique == false)]{setup-info-element-image-container-improved}[:when (unique)]{setup-info-element-image-container-unique}">
		<div class="setup-info-element-image-box sk-icon-148x148 sk-icon-138x138-body">&nbsp;</div>
	</div>
	<div class="setup-info-element-info-container">
		<div class="setup-info-element-info-data-box">
			<div class="setup-info-element-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
			</div>
		</div>
		<div class="setup-info-element-info-data-box">
			<div class="setup-info-element-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
			</div>
		</div>
		<div class="setup-info-element-info-data-box">
			<div class="setup-info-element-info-data-name">Braking <span>[:0.braking]</span></div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.braking/100)*100)]%"></div>
			</div>
		</div>
		<div class="setup-info-element-info-data-box">
			<div class="setup-info-element-info-data-name">Handling <span>[:0.handling]</span></div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.handling/100)*100)]%"></div>
			</div>
		</div>
		<div class="setup-info-element-info-data-box">
			<div class="setup-info-element-info-data-name">Weight <span>[:0.weight]</span> kg</div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.weight/100)*100)]%"></div>
			</div>
		</div>
		<div class="small-element-info-data-box">
			<div class="small-element-info-data-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info progress-bar-info-used270 ui-corner-all-2px" style="width:[:eval floor(0.wear/1000)]%"></div>
			</div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>