<div class="setup-info-element-container [:when (improvement > 0 & unique == false)]{setup-info-element-container-improved}[:when (unique)]{setup-info-element-container-unique} ui-corner-all">
	<div class="setup-info-element-image-container [:when (improvement > 0 & unique == false)]{setup-info-element-image-container-improved}[:when (unique)]{setup-info-element-image-container-unique}">
		<div class="setup-info-element-image-box sk-icon-148x148 sk-icon-138x138-[:0.name]">&nbsp;</div>
	</div>
	<div class="setup-info-element-info-container">
		<div class="setup-info-element-info-data-container">
			<div>Part: <b>[:0.name]</b></div>
			<div>Type: <b>[:0.part_modifier]</b></div>
			<div>Level: <b>[:0.level]</b></div>
		</div>
		<div class="crearfix"></div>
		<div class="small-element-info-data-box">
			<div class="small-element-info-data-name">[:0.parameter1_name]: <span>+[:0.parameter1]</span> [:when (0.parameter1_unit != null)]{[:0.parameter1_unit]}</div>
			<div class="progress-bar-box-info ui-corner-all-2px">
				<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (0.parameter1/100)*100]%"></div>
			</div>
		</div>
		[:when (0.parameter2_name)]{
			<div class="small-element-info-data-box">
				<div class="small-element-info-data-name">[:0.parameter2_name]: <span>+[:0.parameter2]</span> [:when (0.parameter2_unit != null)]{[:0.parameter2_unit]}</div>
				<div class="progress-bar-box-info ui-corner-all-2px">
					<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (0.parameter2/100)*100]%"></div>
				</div>
			</div>
		}
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