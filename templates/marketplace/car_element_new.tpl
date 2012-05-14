<div class="part-element-box ui-corner-all">
	<div class="part-element-image ui-corner-all sk-icon-90x90 sk-icon-90x90-body">&nbsp;</div>
	<div class="part-element-info-box">
		<div class="part-element-info-about">
			<div>Manufacturer:&nbsp;<b>[:0.manufacturer_name]</b></div>
			<div>Model:&nbsp;<b>[:0.name]</b></div>
			<div>Year:&nbsp;<b>[:0.year]</b></div>
			<div>Level:&nbsp;<b>[:0.level]</b></div>
			<div>Price:&nbsp;<b>SK$ [:0.price]</b></div>
		</div>
		<div class="part-element-info-data">
			<div class="part-element-info-data-box-container">
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Top speed <span>[:0.top_speed]</span> (km/h)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Acceleration <span>[:0.acceleration]</span> (s)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Braking <span>[:0.braking]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Handling <span>[:0.handling]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-name">Weight <span>[:0.weight]</span> (kg)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.weight/100)*100)]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="part-element-button-box">
		<div class="part-element-button-box-container">
			[:when (requestParams.action == "Market/model/")]{<a href="#Car/buy?id=[:0.id]" class="button part-button" module="MARKETPLACE_NEWCAR_BUY">buy</a>}
		</div>
	</div>
	<div class="crearfix"></div>
</div>
