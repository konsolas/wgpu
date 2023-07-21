#include <metal_stdlib>

struct DrawIndirectArguments {
    uint vertex_count;
    uint instance_count;
    uint vertex_start;
    uint base_instance;
};

struct DrawIndexedIndirectArguments {
    uint index_count;
    uint instance_count;
    uint index_start;
    uint base_vertex;
    uint base_instance;
};

struct ICBContainer {
    metal::command_buffer cmd_buf [[ id(0) ]];
};

kernel void to_icb_unindexed(
        uint object_index                                   [[ thread_position_in_grid ]],
        constant metal::primitive_type *type                [[ buffer(0) ]],
        device const DrawIndirectArguments *draws           [[ buffer(1) ]],
        device ICBContainer *icb_container                  [[ buffer(2) ]],
        constant uint *count                                [[ buffer(3) ]]
) {
    if (object_index < *count) {
        DrawIndirectArguments args = draws[object_index];
        metal::render_command cmd(icb_container->cmd_buf, object_index);
        cmd.draw_primitives(
            *type,
            args.vertex_start,
            args.vertex_count,
            args.instance_count,
            args.base_instance
        );
    }
}

kernel void to_icb_indexed_u16(
        uint object_index                                   [[ thread_position_in_grid ]],
        constant metal::primitive_type *type                [[ buffer(0) ]],
        device const DrawIndexedIndirectArguments *draws    [[ buffer(1) ]],
        device ICBContainer *icb_container                  [[ buffer(2) ]],
        constant uint *count                                [[ buffer(3) ]],
        device const ushort *index_buffer                   [[ buffer(4) ]]
) {
    if (object_index < *count) {
        DrawIndexedIndirectArguments args = draws[object_index];
        metal::render_command cmd(icb_container->cmd_buf, object_index);
        cmd.draw_indexed_primitives(
            *type,
            args.index_count,
            index_buffer + args.index_start,
            args.instance_count,
            args.base_vertex,
            args.base_instance
        );
    }
}

kernel void to_icb_indexed_u32(
        uint object_index                                   [[ thread_position_in_grid ]],
        constant metal::primitive_type *type                [[ buffer(0) ]],
        device const DrawIndexedIndirectArguments *draws    [[ buffer(1) ]],
        device ICBContainer *icb_container                  [[ buffer(2) ]],
        constant uint *count                                [[ buffer(3) ]],
        device const uint *index_buffer                     [[ buffer(4) ]]
) {
    if (object_index < *count) {
        DrawIndexedIndirectArguments args = draws[object_index];
        metal::render_command cmd(icb_container->cmd_buf, object_index);
        cmd.draw_indexed_primitives(
            *type,
            args.index_count,
            index_buffer + args.index_start,
            args.instance_count,
            args.base_vertex,
            args.base_instance
        );
    }
}
