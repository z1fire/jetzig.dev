const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = jetzig.database.Query(.Blogs)
        .select(&.{})
        .orderBy(.{ .created_at = .descending });
    var result = try request.repo.execute(query);

    var root = try data.root(.object);
    try root.put("blogs", try result.all(query));

    return request.render(.ok);
}

pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.root(.object);

    if (try jetzig.database.Query(.Blogs).find(id).execute(request.repo)) |blog| {
        try root.put("blog", blog);
    } else {
        return request.render(.not_found);
    }
    return request.render(.ok);
}

pub fn new(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    const params = try request.params();
    const title = params.get("title").?;
    const content = params.get("content").?;
    try jetzig.database.Query(.Blogs)
        .insert(.{ .title = title, .content = content })
        .execute(request.repo);
    return request.redirect("/blogs", .moved_permanently);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/blogs", .{});
    try response.expectStatus(.ok);
}

test "get" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/blogs/example-id", .{});
    try response.expectStatus(.ok);
}