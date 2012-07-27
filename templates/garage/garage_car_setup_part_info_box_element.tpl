<div class="setup-part-info-element-image-container [:when (0.improvement > 0 & 0.unique == false)]{setup-part-info-element-image-container-improved}[:when (0.unique)]{setup-part-info-element-image-container-unique} black-icons-100 [:when (0.name == "engine")]{setup-part-info-element-[:0.name]-black}[:when (0.name != "engine")]{setup-part-info-element-image-container-image}" [:when (0.name != "engine")]{style="background-image:url(test_store/[:0.name]/[:0.name]_[:0.d3d_model_id].jpg?t=[:eval TIMESTAMP(0.id)])"}>&nbsp;</div>
<div class="setup-part-info-element-data-container">
	<div class="setup-part-info-element-info-container">
		<div class="setup-part-info-element-infotext-container">
			<div>Part: <span>[:eval CAPITALISEFIRSTLETTER(0.name)]</span></div>
			<div>Type: <span>[:eval CAPITALISEFIRSTLETTER(0.part_modifier)]</span></div>
			<div>Level: <span>[:0.level]</span></div>
		</div>
		<div class="setup-part-info-element-vertical-line"></div>
		<div class="setup-part-info-element-infobar-container">
			<div class="setup-part-info-element-info-data-box">
				<div class="setup-part-info-element-info-data-box-name">[:0.parameter1_name]: <span>+[:0.parameter1]</span> [:when (0.parameter1_unit != null)]{[:0.parameter1_unit]}</div>
				<div class="setup-part-info-element-progress-bar-box ui-corner-all-1px">
					<div class="setup-part-info-element-progress-bar ui-corner-all-1px" style="width:[:eval (0.parameter1/100)*100]%"></div>
				</div>
			</div>
			[:when (0.parameter2_name)]{
				<div class="setup-part-info-element-info-data-box">
					<div class="setup-part-info-element-info-data-box-name">[:0.parameter2_name]: <span>+[:0.parameter2]</span> [:when (0.parameter2_unit != null)]{[:0.parameter2_unit]}</div>
					<div class="setup-part-info-element-progress-bar-box ui-corner-all-1px">
						<div class="setup-part-info-element-progress-bar ui-corner-all-1px" style="width:[:eval (0.parameter2/100)*100]%"></div>
					</div>
				</div>
			}
			<div class="setup-part-info-element-info-data-box">
				<div class="setup-part-info-element-info-data-box-name">Weight <span>+[:0.weight]</span> kg</div>
				<div class="setup-part-info-element-progress-bar-box ui-corner-all-1px">
					<div class="setup-part-info-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
				</div>
			</div>
			[:when (0.unique == false)]{
				<div class="setup-part-info-element-info-data-box">
					<div class="setup-part-info-element-info-data-box-name">Improve <span>[:eval floor(0.improvement/1000)]</span> %</div>
					<div class="setup-part-info-element-progress-bar-box ui-corner-all-2px">
						<div class="setup-part-info-element-progress-bar setup-part-info-element-progress-improve ui-corner-all-1px" style="width:[:eval ((0.improvement/100000)*100)]%"></div>
					</div>
				</div>
			}
			<div class="setup-part-info-element-info-data-box">
				<div class="setup-part-info-element-info-data-box-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
				<div class="setup-part-info-element-progress-bar-box ui-corner-all-2px">
					<div class="setup-part-info-element-progress-bar setup-part-info-element-progress-used ui-corner-all-1px" style="width:[:eval floor(0.wear/1000)]%"></div>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>
<div class="clearfix"></div>