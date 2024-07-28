const std = @import("std");
const debug = std.debug;

pub fn main() !void {
    debug.print("New Zig Project!.\n", .{});
}

const expect = std.testing.expect;

test "it works" {
    std.debug.print("it works!\n", .{});
    std.testing.expect(true == true);
}
