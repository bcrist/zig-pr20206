const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var iter = try std.process.argsWithAllocator(arena.allocator());
    defer iter.deinit();

    _ = iter.next(); // path to exe

    const writeFile = if (@typeInfo(@TypeOf(std.fs.Dir.writeFile)).Fn.params.len == 2) std.fs.Dir.writeFile else std.fs.Dir.writeFile2;

    while (iter.next()) |path| {
        writeFile(std.fs.cwd(), .{
            .sub_path = path,
            .data = "some_target: this_file_does_not_exist.c",
        }) catch |err| {
            std.log.err("failed to write {s}: {}", .{ path, err });
            return;
        };
    }
}
