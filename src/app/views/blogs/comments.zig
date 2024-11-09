const std = @import("std");
const jetzig = @import("jetzig");

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    const params = try request.params();
    const name = params.get("name") orelse return request.render(.unprocessable_entity);
    const content = params.get("content") orelse return request.render(.unprocessable_entity);
    const blog_id = params.get("blog_id") orelse return request.render(.unprocessable_entity);

    const query = jetzig.database.Query(.Comment).insert(.{
        .name = name,
        .content = content,
        .blog_id = blog_id,
    });
    try request.repo.execute(query);

    return request.redirect(
        try request.joinPath(.{ "/blogs", blog_id }),
        .moved_permanently,
    );
}

test "post" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    try app.repo.begin();
    defer app.repo.rollback() catch {};

    try app.repo.insert(.Blog, .{ .id = 1, .title = "Test", .content = "Test", .author = "Bob" });
    const response = try app.request(
        .POST,
        "/blogs/comments",
        .{
            .params = .{
                .name = "Bob",
                .content = "Test message",
                .blog_id = 1,
            },
        },
    );
    try response.expectStatus(.moved_permanently);
}