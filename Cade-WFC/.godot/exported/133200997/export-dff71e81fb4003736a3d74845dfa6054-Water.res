RSRC                     VisualShader            ��������                                            �      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script 	   function    noise_type    seed 
   frequency    offset    fractal_type    fractal_octaves    fractal_lacunarity    fractal_gain    fractal_weighted_strength    fractal_ping_pong_strength    cellular_distance_function    cellular_jitter    cellular_return_type    domain_warp_enabled    domain_warp_type    domain_warp_amplitude    domain_warp_frequency    domain_warp_fractal_type    domain_warp_fractal_octaves    domain_warp_fractal_lacunarity    domain_warp_fractal_gain    width    height    invert    in_3d_space    generate_mipmaps 	   seamless    seamless_blend_skirt    as_normal_map    bump_strength 
   normalize    color_ramp    noise    source    texture    texture_type    op_type 	   operator    parameter_name 
   qualifier    default_value_enabled    default_value 	   constant    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    nodes/vertex/0/position    nodes/vertex/2/node    nodes/vertex/2/position    nodes/vertex/3/node    nodes/vertex/3/position    nodes/vertex/4/node    nodes/vertex/4/position    nodes/vertex/5/node    nodes/vertex/5/position    nodes/vertex/6/node    nodes/vertex/6/position    nodes/vertex/7/node    nodes/vertex/7/position    nodes/vertex/8/node    nodes/vertex/8/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_ax5kn �      %   local://VisualShaderNodeUVFunc_4dpt0 �         local://FastNoiseLite_cijrw          local://NoiseTexture2D_s4ai6 i      &   local://VisualShaderNodeTexture_5jl2k �      $   local://VisualShaderNodeInput_nwck5 �      $   local://VisualShaderNodeInput_6ojuj       *   local://VisualShaderNodeMultiplyAdd_54iwu N      '   local://VisualShaderNodeVectorOp_g8bb2 �      -   local://VisualShaderNodeColorParameter_v2jwy W         local://NoiseTexture2D_kups8 �      &   local://VisualShaderNodeTexture_wdabc       '   local://VisualShaderNodeVectorOp_vdq2h P      %   local://VisualShaderNodeUVFunc_3c21g �      $   local://VisualShaderNodeInput_sjguo 0         local://FastNoiseLite_uiti7 g         local://NoiseTexture2D_u5i7w �      &   local://VisualShaderNodeTexture_pjeks       $   local://VisualShaderNodeInput_21wph L      %   local://VisualShaderNodeUVFunc_5nnag �      '   local://VisualShaderNodeVectorOp_eygin �      '   local://VisualShaderNodeVectorOp_um2vt c      ,   local://VisualShaderNodeFloatConstant_0nwr4 �      ,   local://VisualShaderNodeFloatConstant_yuptb "         local://VisualShader_jklx1 P         VisualShaderNodeInput             time          VisualShaderNodeUVFunc                   
   ���=���=      
                    FastNoiseLite                                        �?         NoiseTexture2D    "         (                     VisualShaderNodeTexture    *                     VisualShaderNodeInput             vertex          VisualShaderNodeInput             normal          VisualShaderNodeMultiplyAdd                    2                         2     �?  �?  �?  �?      2                   ,                  VisualShaderNodeVectorOp                                            ��>��>��>-                  VisualShaderNodeColorParameter    .         ColorParameter 0         1      д4>��?  �?  �?         NoiseTexture2D          �        �  "         (                     VisualShaderNodeTexture    *         
            VisualShaderNodeVectorOp                                                                          ,                  VisualShaderNodeUVFunc                   
   ��L=��L=      
                    VisualShaderNodeInput             time          FastNoiseLite             	                                    �?         NoiseTexture2D          �        �  "         (                     VisualShaderNodeTexture    *                     VisualShaderNodeInput             time          VisualShaderNodeUVFunc                   
   ��L���̽      
                    VisualShaderNodeVectorOp                                                                ,         -                  VisualShaderNodeVectorOp                                                  �?  �?  �?  �?,         -                  VisualShaderNodeFloatConstant    2        �?         VisualShaderNodeFloatConstant             VisualShader -   3      �  shader_type spatial;
uniform sampler2D tex_vtx_4;
uniform vec4 ColorParameter : source_color = vec4(0.176471, 0.560784, 1.000000, 1.000000);
uniform sampler2D tex_frg_3;
uniform sampler2D tex_frg_7;



void vertex() {
// Input:2
	float n_out2p0 = TIME;


// UVFunc:3
	vec2 n_in3p1 = vec2(0.10000, 0.10000);
	vec2 n_out3p0 = vec2(n_out2p0) * n_in3p1 + UV;


// Texture2D:4
	vec4 n_out4p0 = texture(tex_vtx_4, n_out3p0);


// Input:6
	vec3 n_out6p0 = NORMAL;


// VectorOp:8
	vec3 n_in8p1 = vec3(0.15000, 0.15000, 0.15000);
	vec3 n_out8p0 = n_out6p0 * n_in8p1;


// Input:5
	vec3 n_out5p0 = VERTEX;


// MultiplyAdd:7
	vec4 n_out7p0 = fma(n_out4p0, vec4(n_out8p0, 0.0), vec4(n_out5p0, 0.0));


// Output:0
	VERTEX = vec3(n_out7p0.xyz);


}

void fragment() {
// ColorParameter:2
	vec4 n_out2p0 = ColorParameter;


// Input:6
	float n_out6p0 = TIME;


// UVFunc:5
	vec2 n_in5p1 = vec2(0.05000, 0.05000);
	vec2 n_out5p0 = vec2(n_out6p0) * n_in5p1 + UV;


// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, n_out5p0);


// Input:8
	float n_out8p0 = TIME;


// UVFunc:9
	vec2 n_in9p1 = vec2(-0.05000, -0.10000);
	vec2 n_out9p0 = vec2(n_out8p0) * n_in9p1 + UV;


// Texture2D:7
	vec4 n_out7p0 = texture(tex_frg_7, n_out9p0);


// VectorOp:10
	vec4 n_out10p0 = n_out3p0 * n_out7p0;


// VectorOp:11
	vec4 n_in11p1 = vec4(1.25000, 1.25000, 1.25000, 1.25000);
	vec4 n_out11p0 = pow(n_out10p0, n_in11p1);


// VectorOp:4
	vec4 n_out4p0 = n_out2p0 + n_out11p0;


// FloatConstant:12
	float n_out12p0 = 1.500000;


// FloatConstant:13
	float n_out13p0 = 0.000000;


// Output:0
	ALBEDO = vec3(n_out4p0.xyz);
	ALPHA = n_out12p0;
	ROUGHNESS = n_out13p0;
	EMISSION = vec3(n_out11p0.xyz);


}
 4   
   �'ĶDK�J   
     D  �CK             L   
    � �  �CM            N   
     ��  �CO            P   
     9�  �CQ            R   
     ��  �DS            T   
    ���  fDU            V   
     pB  DW            X   
     9� ��DY                                                                                                          Z   
     zD  C[         	   \   
     H�  ��]            ^   
     ��   B_            `   
     �C  H�a            b   
     ��  �Bc            d   
    @&�  Ce            f   
     ��  Dg            h   
      �  Di            j   
    ���  Dk            l   
     ��  �Cm            n   
     ��  �Co            p   
     �C  9Dq            r   
     �C  aDs       4                                                           	                     	             
              
      
                                                                           RSRC