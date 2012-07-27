<div class="part-element-box ui-corner-all">
	<div class="part-element-image ui-corner-all sk-icon-90x90 sk-icon-90x90-[:name]">&nbsp;[:when (improvement > 0)]{<div class="part-element-improvement-image ui-corner-all"></div>}</div>
	<div class="part-element-info-box">
		<div class="part-element-info-about">
			<div>Manufacturer:&nbsp;<b>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</b></div>
			<div>Model:&nbsp;<b>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</b></div>
			<div>Type:&nbsp;<b>[:part_modifier]</b></div>
			<div>Level:&nbsp;<b>[:level]</b></div>
			<div>Price:&nbsp;<b>SK$ [:price]</b></div>
		</div>
		<div class="part-element-info-data">
			<div class="part-element-info-data-box-container">
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">[:parameter1_name] <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{([:parameter1_unit])}</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((parameter1/100)*100)]%"></div>
					</div>
				</div>
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Weight <span>+[:weight]</span> (kg)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((weight/100)*100)]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="part-element-button-box">
		<div class="part-element-button-box-container">
			<a href="#Market/return?id=[:id]" class="button part-button" module="MARKETPLACE_USED_BUY">return</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
