const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var object = try data.object();

    try object.put("url", data.string("https://jetzig.dev/"));
    try object.put("title", data.string("Jetzig Website"));
    try object.put("message", data.string("Welcome to Jetzig!"));

    return request.render(.ok);
}
