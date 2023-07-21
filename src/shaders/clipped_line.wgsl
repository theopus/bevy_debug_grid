#import bevy_pbr::mesh_view_bindings as bindings
#import bevy_pbr::mesh_vertex_output       MeshVertexOutput

const LOW: f32 = 0.001;
const HIGH: f32 = 0.002;

struct LineMaterial {
    color: vec4<f32>,
    alignment: vec3<f32>,
    radius: f32,
    offset: f32,
    x_axis_color: vec4<f32>,
    y_axis_color: vec4<f32>,
    z_axis_color: vec4<f32>,
};

@group(1) @binding(0)
var<uniform> material: LineMaterial;

@fragment
fn fragment(
    in: MeshVertexOutput
) -> @location(0) vec4<f32> {
    let delta = (bindings::view.world_position.xyz - in.world_position.xyz) * material.alignment;
    let dist_squared = dot(delta, delta);
    let radius_squared = material.radius * material.radius;
    if dist_squared > radius_squared {
        discard;
    }
    let offset_position = in.world_position.xyz - (vec3(1.0) - material.alignment) * material.offset;
    let xmix = smoothstep(LOW, HIGH, max(abs(offset_position.y), abs(offset_position.z)));
    let ymix = smoothstep(LOW, HIGH, max(abs(offset_position.x), abs(offset_position.z)));
    let zmix = smoothstep(LOW, HIGH, max(abs(offset_position.x), abs(offset_position.y)));

    return mix(material.x_axis_color, mix(material.y_axis_color, mix(material.z_axis_color, material.color, zmix), ymix), xmix);
}
