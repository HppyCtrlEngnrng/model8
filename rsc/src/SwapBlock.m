function SwapBlock(src_path, dst_path)
    dst_model_path = split(src_path, "/");
    load_system(dst_model_path(1));
    h_src_blk = find_system(src_path, "SearchDepth", 0, "FindAll", "on");
    h_dst_blk = find_system(dst_path, "SearchDepth", 0, "FindAll", "on");

    pos_dst = get_param(h_dst_blk, "Position");
    delete_block(h_dst_blk);

    h_dst_blk = add_block(h_src_blk, dst_path);
    set_param(h_dst_blk, "Position", pos_dst);
    close_system(dst_model_path(1));
end