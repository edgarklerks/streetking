<form id="edit_form" action="car_instance/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<input type="hidden" name="active" value="false"/>
	<input type="hidden" name="garage_id" value="0"/>
	<input type="hidden" name="prototype" value="true"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-container1">
			<div class="edit-element-container1-data1">
				<div><label>car id:</label><input type="text" name="car_id" value="[:0.car_id]"/></div>
<!--				<div><label>id:</label><input type="text" name="id" value="[:0.id]"/></div>-->
<!--				<div><label>garage id:</label><input type="text" name="garage_id" value="[:0.garage_id]"/></div>-->
				<div><label>prototype name:</label><input type="text" name="prototype_name" value="[:0.prototype_name]"/></div>
<!--				<div><label>active:</label>[:eval OPTIONTRUEFALSE("[\"active\",\""+0.active+"\"]")]</div>-->
				<div><label>deleted:</label>[:eval OPTIONTRUEFALSE("[\"deleted\",\""+0.deleted+"\"]")]</div>
<!--				<div><label>prototype:</label>[:eval OPTIONTRUEFALSE("[\"prototype\",\""+0.prototype+"\"]")]</div>-->
				<div><label>available:</label>[:eval OPTIONTRUEFALSE("[\"prototype_available\",\""+0.prototype_available+"\"]")]</div>
				<div><label>claimable:</label>[:eval OPTIONTRUEFALSE("[\"prototype_claimable\",\""+0.prototype_claimable+"\"]")]</div>
			</div>
			<div class="edit-element-container1-data2">
				<div class="edit-element-container1-data2-inner">
					<div id="car_ready" class="edit-element-container1-car-ready"></div>
					<div id="car_prototype_parameters" class="edit-element-container1-hidden-data">loading...</div>
				</div>
			</div>
			<div class="edit-element-container1-image" style='background-image:url([:eval IMAGESERVER("[\"car\",\""+0.car_id+"\",\"car\"]")])'></div>
			<div class="clearfix"></div>
		</div>
		<div class="edit-element-data-container2">
			<div class="edit-element-data-container2-title">
				<label>Car parts</label>
				<a href="#car_instance/get?id=[:0.id]" class="button" module="CAR_PROTOTYPE_PARTS_ADD">add new part</a>
			</div>
			<div class="clearfix"></div>
			<div class="edit-element-data-container2-box inner-scroll-box">
				<div id="car_prototype_part_list" class="edit-element-data-container2-box-part-list">Loading...</div>
			</div>
		</div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>