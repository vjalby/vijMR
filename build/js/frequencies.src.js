
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"resps","title":"Option Variables","type":"Variables","required":true,"suggested":["nominal"],"permitted":["factor"]},{"name":"endorsed","title":"Counted Value","type":"Integer","default":1},{"name":"optionname","title":"Option name","type":"String","default":"Options"},{"name":"order","title":"Sorting","type":"List","options":[{"title":"Decreasing","name":"decreasing"},{"title":"Increasing","name":"increasing"},{"title":"None","name":"none"}],"default":"decreasing"},{"name":"showTotal","title":"Total","type":"Bool","default":true},{"name":"showCounts","title":"Counts","type":"Bool","default":true},{"name":"showResponses","title":"% of Responses","type":"Bool","default":true},{"name":"showCases","title":"% of Cases","type":"Bool","default":true},{"name":"yaxis","title":"Y-Axis","type":"List","options":[{"title":"Counts","name":"counts"},{"title":"% of Responses","name":"responses"},{"title":"% of Cases","name":"cases"}],"default":"cases"},{"name":"size","title":"","type":"List","options":[{"title":"Small (300x200)","name":"small"},{"title":"Medium (400x300)","name":"medium"},{"title":"Large (600x400)","name":"large"},{"title":"Huge (800x500)","name":"huge"}],"default":"medium"}];

const view = function() {
    
    this.handlers = { }

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Multiple Response Frequencies",
    jus: "3.0",
    type: "root",
    stage: 0, //0 - release, 1 - development, 2 - proposed
    controls: [
		{
			type: DefaultControls.VariableSupplier,
			typeName: 'VariableSupplier',
			persistentItems: false,
			stretchFactor: 1,
			controls: [
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "Option Variables",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "resps",
							isTarget: true
						}
					]
				}
			]
		},
		{
			type: DefaultControls.Label,
			typeName: 'Label',
			label: "Option Variables",
			controls: [
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					stretchFactor: 1,
					style: "inline",
					controls: [
						{
							type: DefaultControls.TextBox,
							typeName: 'TextBox',
							name: "endorsed",
							format: FormatDef.number,
							stretchFactor: 1
						},
						{
							type: DefaultControls.TextBox,
							typeName: 'TextBox',
							name: "optionname",
							format: FormatDef.string,
							stretchFactor: 1
						}
					]
				}
			]
		},
		{
			type: DefaultControls.LayoutBox,
			typeName: 'LayoutBox',
			margin: "large",
			stretchFactor: 1,
			controls: [
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					cell: {"column":0,"row":0},
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Table",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "showTotal"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "showCounts"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "showResponses"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "showCases"
								}
							]
						}
					]
				},
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					cell: {"column":1,"row":0},
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Sorting",
							controls: [
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "order_increasing",
									optionName: "order",
									optionPart: "increasing",
									label: "Increasing"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "order_decreasing",
									optionName: "order",
									optionPart: "decreasing",
									label: "Decreasing"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "order_none",
									optionName: "order",
									optionPart: "none",
									label: "None"
								}
							]
						}
					]
				},
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					cell: {"column":2,"row":0},
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Plot",
							controls: [
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "yaxis_counts",
									optionName: "yaxis",
									optionPart: "counts",
									label: "Counts"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "yaxis_responses",
									optionName: "yaxis",
									optionPart: "responses",
									label: "% of Responses"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "yaxis_cases",
									optionName: "yaxis",
									optionPart: "cases",
									label: "% of Cases"
								}
							]
						}
					]
				}
			]
		},
		{
			type: DefaultControls.Label,
			typeName: 'Label',
			label: "Plot Size",
			controls: [
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					stretchFactor: 1,
					style: "inline",
					controls: [
						{
							type: DefaultControls.ComboBox,
							typeName: 'ComboBox',
							name: "size"
						}
					]
				}
			]
		}
	]
});

module.exports = { view : view, options: options };
