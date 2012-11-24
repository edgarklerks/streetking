<form id="edit_form" action="rule/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>once:</label>
				<!--<input type="text" name="once" value="[:0.once]"/>-->
				[:eval OPTIONTRUEFALSE("[\"once\",\""+0.once+"\"]")]
			</div>
			<div><label>rule:</label><input type="text" name="rule" value="[:0.rule]" style="width:300px"/></div>
		</div>
		<div class="edit-element-image-box">&nbsp;</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>
