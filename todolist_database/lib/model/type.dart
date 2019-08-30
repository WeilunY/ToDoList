class Type {
    int code;
    String name;

    Type({
        this.code,
        this.name,
    });

    factory Type.fromJson(Map<String, dynamic> json) => new Type(
        code: json["code"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
    };
}
