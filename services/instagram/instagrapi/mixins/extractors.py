from __future__ import annotations
from typing import Any, Dict, List, NamedTuple, Optional
import html
import json
import datetime
import re

class MyClass:
    def __init__(self, value: Any) -> None:
        self.value = value

    def my_method(self, other_value: Optional[str]) -> Dict[str, Any]:
        result = {"success": True}

        if other_value is not None:
            result["other_value"] = html.escape(other_value)

        return result

def my_function(data: List[MyClass]) -> str:
    return json.dumps([vars(item) for item in data])

if __name__ == "__main__":
    my_data = [MyClass(datetime.datetime.now()), MyClass("test")]
    print(my_function(my_data))
