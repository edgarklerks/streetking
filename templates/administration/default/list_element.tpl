<div style="margin-left:10px; margin-bottom:10px;">
	<div style="float:left;">
		[:when (f)]{
			[:repeat data:f as:ff] {
				<div>[:ff.name]: [:ff.value]</div>
			}
		}
	</div>
	<div style="float:left;">
		<a href="#[:action]?id=[:id]" class="button" module="[:module]">edit</a>
	</div>
	<div style="clear:both;"></div>
</div>