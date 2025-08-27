import { Union, Record } from "./fable_modules/fable-library-js.4.25.0/Types.js";
import { union_type, record_type, int32_type } from "./fable_modules/fable-library-js.4.25.0/Reflection.js";
import { Cmd_none } from "./fable_modules/Fable.Elmish.5.0.2/cmd.fs.js";
import { Props_TouchableWithoutFeedbackProperties, Props_TouchableHighlightProperties, Props_TouchableHighlightProperties_Style_624235F5, Props_TextStyle, Props_TextProperties_Style_624235F5, Props_ViewStyle, Props_FlexStyle, Props_ViewProperties_Style_624235F5 } from "./fable_modules/Fable.React.Native.4.0.0/Fable.ReactNative.fs.js";
import { singleton, ofArray } from "./fable_modules/fable-library-js.4.25.0/List.js";
import * as react from "react";
import { View, TouchableHighlight, Text as Text$ } from "react-native";
import { keyValueList } from "./fable_modules/fable-library-js.4.25.0/MapUtil.js";
import { int32ToString } from "./fable_modules/fable-library-js.4.25.0/Util.js";
import { ProgramModule_mkProgram, ProgramModule_withConsoleTrace, ProgramModule_run } from "./fable_modules/Fable.Elmish.5.0.2/program.fs.js";
import { Program_withReactNative } from "./fable_modules/Fable.Elmish.React.5.0.0/react-native.fs.js";

export class Model extends Record {
    constructor(Counter) {
        super();
        this.Counter = (Counter | 0);
    }
}

export function Model_$reflection() {
    return record_type("App.Model", [], Model, () => [["Counter", int32_type]]);
}

export class Message extends Union {
    constructor() {
        super();
        this.tag = 0;
        this.fields = [];
    }
    cases() {
        return ["Increment"];
    }
}

export function Message_$reflection() {
    return union_type("App.Message", [], Message, () => [[]]);
}

export function init() {
    return [new Model(0), Cmd_none()];
}

export function update(msg, model) {
    return [new Model(model.Counter + 1), Cmd_none()];
}

export function view(model, dispatch) {
    let child, props, props_2, props_5, text_1;
    const props_7 = singleton(Props_ViewProperties_Style_624235F5(ofArray([new Props_FlexStyle(14, [1]), new Props_FlexStyle(21, ["center"]), new Props_ViewStyle(1, ["#131313"])])));
    const children_3 = [(child = ((props = singleton(Props_TextProperties_Style_624235F5(singleton(new Props_TextStyle(0, ["#ffffff"])))), react.createElement(Text$, keyValueList(props, 1), "Press me"))), (props_2 = ofArray([Props_TouchableHighlightProperties_Style_624235F5(singleton(new Props_FlexStyle(37, [10]))), new Props_TouchableHighlightProperties(4, ["#f6f6f6"]), new Props_TouchableWithoutFeedbackProperties(8, [() => {
        dispatch(new Message());
    }])]), react.createElement(TouchableHighlight, keyValueList(props_2, 1), child))), (props_5 = singleton(Props_TextProperties_Style_624235F5(ofArray([new Props_TextStyle(0, ["#ffffff"]), new Props_TextStyle(2, [30]), new Props_TextStyle(7, ["center"])]))), (text_1 = int32ToString(model.Counter), react.createElement(Text$, keyValueList(props_5, 1), text_1)))];
    return react.createElement(View, keyValueList(props_7, 1), ...children_3);
}

ProgramModule_run(Program_withReactNative("Temp", ProgramModule_withConsoleTrace(ProgramModule_mkProgram(init, update, view))));

