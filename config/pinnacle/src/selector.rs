#![allow(dead_code)]

use std::collections::HashMap;

use pinnacle_api::{
    layout::{LayoutGenerator, LayoutNode},
    tag::TagHandle,
};

/// A [`LayoutGenerator`] that keeps track of layouts per tag and provides
/// methods to cycle between them.
pub struct Selector<T> {
    /// The layouts this generator will cycle between.
    pub layouts: Vec<T>,
    tag_indices: HashMap<u32, usize>,
    current_tag: Option<TagHandle>,
}

impl<T> Selector<T> {
    /// Creates a new [`Cycle`] from the given [`LayoutGenerator`]s.
    ///
    /// # Examples
    ///
    /// ```
    /// # use pinnacle_api::layout::generators::Cycle;
    /// # use pinnacle_api::layout::generators::MasterStack;
    /// # use pinnacle_api::layout::generators::Dwindle;
    /// # use pinnacle_api::layout::generators::Corner;
    /// # use pinnacle_api::layout::LayoutGenerator;
    /// let cycler = Cycle::new([
    ///     Box::<MasterStack>::default() as Box<dyn LayoutGenerator + Send>,
    ///     Box::<Dwindle>::default() as _,
    ///     Box::<Corner>::default() as _,
    /// ]);
    /// ```
    pub fn new(layouts: impl IntoIterator<Item = T>) -> Self {
        Self {
            layouts: layouts.into_iter().collect(),
            tag_indices: HashMap::default(),
            current_tag: None,
        }
    }

    /// Cycles the layout forward on the given tag.
    pub fn cycle_layout_forward(&mut self, tag: &TagHandle) {
        let index = self.tag_indices.entry(tag.id()).or_default();
        *index += 1;
        if *index >= self.layouts.len() {
            *index = 0;
        }
    }

    /// Cycles the layout backward on the given tag.
    pub fn cycle_layout_backward(&mut self, tag: &TagHandle) {
        let index = self.tag_indices.entry(tag.id()).or_default();
        if let Some(i) = index.checked_sub(1) {
            *index = i;
        } else {
            *index = self.layouts.len().saturating_sub(1);
        }
    }

    /// Retrieves the current layout.
    ///
    /// Returns `None` if no layouts were given.
    pub fn current_layout(&self, tag: &TagHandle) -> Option<&T> {
        self.layouts
            .get(self.tag_indices.get(&tag.id()).copied().unwrap_or_default())
    }

    /// Sets the current tag to choose a layout for.
    pub fn set_current_tag(&mut self, tag: TagHandle) {
        self.current_tag = Some(tag);
    }

    /// Gets a (most-likely) unique identifier for the current layout tree.
    /// This is guaranteed to be greater than zero.
    pub fn current_tree_id(&self) -> u32 {
        let tag_id = self
            .current_tag
            .as_ref()
            .map(|tag| tag.id())
            .unwrap_or_default();
        let layout_id = self.tag_indices.get(&tag_id).copied().unwrap_or_default();

        ((tag_id & u16::MAX as u32) | ((layout_id as u32 & u16::MAX as u32) << 16)) + 1
    }

    pub fn set_layout(&mut self, tag: &TagHandle, new_index: usize) {
        if new_index >= self.layouts.len() {
            return;
        }

        let index = self.tag_indices.entry(tag.id()).or_default();
        *index = new_index;
    }
}

impl<T: LayoutGenerator> LayoutGenerator for Selector<T> {
    fn layout(&self, window_count: u32) -> LayoutNode {
        let Some(current_tag) = self.current_tag.as_ref() else {
            return LayoutNode::new();
        };
        let Some(current_layout) = self.current_layout(current_tag) else {
            return LayoutNode::new();
        };
        current_layout.layout(window_count)
    }
}
